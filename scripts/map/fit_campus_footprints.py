import argparse
import json
import hashlib
import math
import sys
from pathlib import Path

import numpy as np
from shapely import make_valid
from shapely.affinity import affine_transform
from shapely.geometry import LineString, Polygon
from shapely.ops import polygonize, unary_union
from shapely.ops import nearest_points

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / 'output/campus-map/georeference'
sys.path.insert(0, str(ROOT / 'scripts/map'))
from pulse_native_geometry import area_polygons

SETTINGS = {'v-86': (7331729,55.661445,37.477049), 's-20': (15743979,55.794259,37.701448)}


def load(campus):
    relation_id, lat, lon = SETTINGS[campus]
    osm = json.loads((OUT / f'osm-{campus}.json').read_text(encoding='utf-8'))
    relation = next(e for e in osm['elements'] if e['type']=='relation' and e['id']==relation_id)
    def project(p):
        return (p['lon']-lon)*111320*math.cos(math.radians(lat)), -(p['lat']-lat)*111320
    outers = list(polygonize([LineString([project(p) for p in m['geometry']]) for m in relation['members'] if m['role']=='outer']))
    inners = list(polygonize([LineString([project(p) for p in m['geometry']]) for m in relation['members'] if m['role']=='inner']))
    target = unary_union(outers).difference(unary_union(inners))
    plan = json.loads((ROOT/f'scripts/map/source/{campus}_plan.json').read_text(encoding='utf-8'))['plan']
    campus_doc = json.loads((ROOT/f'packages/app_ui/assets/maps/pulse/campus_{campus}.json').read_text(encoding='utf-8'))
    floors={}
    for f in campus_doc['floors']:
        areas = area_polygons(plan['layers'][f['source_layer_id']])
        polygons=[make_valid(Polygon([(x*.01,y*.01) for x,y in a['polygon']], [[(x*.01,y*.01) for x,y in ring] for ring in a['holes']])) for a in areas.values()]
        shape=unary_union(polygons).buffer(.1).buffer(-.1).simplify(.15,preserve_topology=True)
        floors[f['id']]={'floor':f,'shape':shape}
    return target,floors,relation


def rings(shape):
    for polygon in getattr(shape,'geoms',[shape]):
        if polygon.geom_type!='Polygon':continue
        yield polygon.exterior
        yield from polygon.interiors


def draw_shapes(campus, target, floors):
    from PIL import Image, ImageDraw

    entries=[('OSM',target)]+[(k,v['shape']) for k,v in floors.items()]
    width=1280;cell=320;rows=math.ceil(len(entries)/4)
    image=Image.new('RGB',(width,rows*350),'white');draw=ImageDraw.Draw(image)
    for index,(label,shape) in enumerate(entries):
        x0=(index%4)*cell;y0=(index//4)*350
        minx,miny,maxx,maxy=shape.bounds;scale=270/max(maxx-minx,maxy-miny)
        for ring in rings(shape):
            points=[(x0+25+(x-minx)*scale,y0+30+(y-miny)*scale) for x,y in ring.coords]
            draw.line(points,fill='#215b92',width=2)
        draw.text((x0+10,y0+310),label,fill='black')
        draw.text((x0+10,y0+327),f'{maxx-minx:.1f} x {maxy-miny:.1f} m  area={shape.area:.0f}',fill='black')
    image.save(OUT/f'{campus}-footprints.png')


def fit_shape(source,target):
    source=source.simplify(.5);target=target.simplify(.3)
    center=np.array(source.centroid.coords[0]);tc=np.array(target.centroid.coords[0])
    def matrix(p):
        angle,sx,sy,shear,tx,ty=p
        c,s=math.cos(angle),math.sin(angle)
        linear=np.array([[c,-s],[s,c]])@np.array([[sx,shear],[0,sy]])
        shift=tc+np.array([tx,ty])-linear@center
        return [*linear[0],*linear[1],*shift]
    def score(p):
        if not(.5<p[1]<2 and .5<p[2]<2 and abs(p[3])<.25):return -1
        warped=affine_transform(source,matrix(p))
        intersection=warped.intersection(target).area
        return intersection/(warped.area+target.area-intersection)
    scale=math.sqrt(target.area/source.area)
    starts=[]
    for degrees in range(0,360,5):
        p=np.array([math.radians(degrees),scale,scale,0,0,0],dtype=float)
        starts.append((score(p),p))
    candidates=[]
    for _,start in sorted(starts,key=lambda row:row[0],reverse=True)[:4]:
        p=start.copy();best=score(p)
        steps=np.array([math.radians(5),.04,.04,.02,3,3])
        for _ in range(200):
            improved=False
            for i in range(6):
                for sign in (-1,1):
                    q=p.copy();q[i]+=steps[i]*sign;value=score(q)
                    if value>best+1e-7:p=q;best=value;improved=True
            if not improved:
                steps*=.5
                if steps[4]<.04:break
        candidates.append((best,p,matrix(p)))
    return max(candidates,key=lambda row:row[0]),candidates


def draw_fit(campus,target,source,matrix):
    from PIL import Image, ImageDraw

    predicted=affine_transform(source,matrix)
    minx,miny,maxx,maxy=target.union(predicted).bounds
    scale=900/max(maxx-minx,maxy-miny)
    im=Image.new('RGB',(1000,1000),'white');draw=ImageDraw.Draw(im)
    for shape,color in ((target,'#172b48'),(predicted,'#f06527')):
        for ring in rings(shape):
            draw.line([(45+(x-minx)*scale,45+(y-miny)*scale) for x,y in ring.coords],fill=color,width=3)
    draw.text((20,15),campus+'  OSM=navy / registered floor=orange',fill='black')
    im.save(OUT/f'{campus}-fit.png')


def export_fit(campus,target,floors,relation,ref,source,score,params,matrix,visualize=False):
    _,lat,lon=SETTINGS[campus]
    horizontal=111320*math.cos(math.radians(lat))
    linear=np.array(matrix[:4]).reshape(2,2);shift=np.array(matrix[4:])
    def geographic(p):return {'latitude':lat-p[1]/111320,'longitude':lon+p[0]/horizontal}
    predicted=affine_transform(source,matrix)
    errors=[]
    for left,right in ((predicted.boundary,target.boundary),(target.boundary,predicted.boundary)):
        errors.extend(left.interpolate(float(d)).distance(right) for d in np.linspace(0,left.length,max(100,math.ceil(left.length))))
    errors=np.array(errors)
    reference=floors[ref]['floor'];minx,miny,*_=map(float,reference['source_view_box'].split());scale=reference['source_coordinate_scale']
    coords=list(source.exterior.simplify(1).coords)
    pairs=[]
    for i in np.linspace(0,len(coords)-2,min(16,len(coords)-1),dtype=int):
        native=np.array(coords[i]);local=linear@native+shift
        point=__import__('shapely').geometry.Point(local)
        matched=nearest_points(point,target.boundary)[1]
        pairs.append({'source_canonical':{'x':(native[0]*100-minx)*scale,'y':(native[1]*100-miny)*scale},
                      'osm_boundary':geographic(matched.coords[0]),'residual_m':point.distance(matched),
                      'kind':'nearest_boundary_after_shape_registration_not_surveyed_control'})
    floor_results=[]
    for floor_id,value in floors.items():
        floor=value['floor'];minx,miny,*_=map(float,floor['source_view_box'].split());scale=floor['source_coordinate_scale']
        a=linear*(.01/scale);b=linear@np.array([minx*.01,miny*.01])+shift
        anchors=[]
        for x,y in ((0,0),(floor['width'],0),(0,floor['height']),(floor['width'],floor['height'])):
            anchors.append({'x':x,'y':y,**geographic(a@np.array([x,y])+b)})
        floor_results.append({'floor_id':floor_id,'source_layer_id':floor['source_layer_id'],
                              'canonical_to_local_east_south_m':[float(n) for n in [*a[0],*a[1],*b]],
                              'anchors':anchors,'anchor_kind':'affine_model_corner_not_individually_observed',
                              'method':'reference_floor_boundary_fit' if floor_id==ref else 'inherited_native_coordinate_frame',
                              'independently_fitted':floor_id==ref})
    osm_path=OUT/f'osm-{campus}.json';osm=json.loads(osm_path.read_text(encoding='utf-8'))
    limitations=['Boundary fit residual is not geodetic accuracy; OSM and source plans may be outdated or distorted.',
                 'No surveyed indoor control points or matching room references exist in this OSM snapshot.',
                 'Non-reference floors inherit the native drawing frame; upper floors have partial footprints and are not independently fitted.',
                 'Anchors encode the affine approximation, not individually observed geographic points.']
    if campus=='v-86':
        limitations.extend(['The detached rectangular block at native x=-93.7..-23.7 m, y=-135.3..-69.1 m is excluded from fitting and is NOT reliably aligned by this matrix.',
                            'The north wing tip differs by approximately 20 m; no single affine transform matches all architectural extents exactly.',
                            'This is a partial main-building alignment. Do not label every room or detached structure geodetically verified.'])
    return {'campus_id':campus,'status':'approximate_partial_main_building' if campus=='v-86' else 'approximate_footprint_alignment',
            **({'excluded_native_bounds_m':list(min(floors[ref]['shape'].geoms,key=lambda polygon:polygon.area).bounds)} if campus=='v-86' else {}),
            'reference_floor_id':ref,'reference_frame':{'latitude':lat,'longitude':lon,'x':'local east metres','y':'local south metres'},
            'native_meters_to_local_east_south_m':[float(n) for n in matrix],
            'reference_fit':{'iou':score,'rotation_degrees':math.degrees(params[0]),
                             'symmetric_boundary_residual_m':{'median':float(np.median(errors)),'p95':float(np.percentile(errors,95)),'max':float(errors.max())},
                             'residual_sampling_step_m':1,'geodetic_accuracy_m':None},
            'osm':{'relation_id':relation['id'],'source_url':f"https://www.openstreetmap.org/relation/{relation['id']}",
                   'member_way_ids':[m['ref'] for m in relation['members']],
                   'snapshot_path':str(osm_path),'snapshot_sha256':hashlib.sha256(osm_path.read_bytes()).hexdigest(),
                   'timestamp_osm_base':osm['osm3s']['timestamp_osm_base'],'attribution':'© OpenStreetMap contributors'},
            'source_plan_sha256':hashlib.sha256((ROOT/f'scripts/map/source/{campus}_plan.json').read_bytes()).hexdigest(),
            'boundary_correspondences':pairs,'floors':floor_results,'limitations':limitations,
            'visual_check':str(OUT/f'{campus}-fit.png') if visualize else None}


if __name__=='__main__':
    parser=argparse.ArgumentParser(description='Fit reviewed campus floor footprints to local OpenStreetMap snapshots without changing map assets.')
    parser.add_argument('--workdir',type=Path,default=OUT,help='Directory containing osm-v-86.json and osm-s-20.json; also receives fit reports.')
    parser.add_argument('--plots',action='store_true',help='Write visual overlays as PNGs; requires optional Pillow.')
    args=parser.parse_args()
    OUT=args.workdir.expanduser().resolve()
    if args.plots:
        try:
            from PIL import Image
        except ImportError:
            parser.error('--plots requires Pillow; omit it to compute fits with NumPy and Shapely only.')
    exported=[]
    for campus in SETTINGS:
        target,floors,relation=load(campus)
        if args.plots:
            draw_shapes(campus,target,floors)
        ref='v-86-floor1' if campus=='v-86' else 's-20-floor2'
        shape=floors[ref]['shape']
        if campus=='v-86':shape=max(shape.geoms,key=lambda p:p.area)
        (score,params,matrix),candidates=fit_shape(shape,target)
        print(campus,'IoU',score,'params',params.tolist(),'matrix',matrix,flush=True)
        if args.plots:
            draw_fit(campus,target,shape,matrix)
        (OUT/f'{campus}-initial-fit.json').write_text(json.dumps({'campus':campus,'reference_floor':ref,'iou':score,'params':params.tolist(),'native_meters_to_local_east_south':matrix,'candidates':[s for s,p,m in candidates]},indent=2),encoding='utf-8')
        exported.append(export_fit(campus,target,floors,relation,ref,shape,score,params,matrix,visualize=args.plots))
    (OUT/'footprint-fits.json').write_text(json.dumps({'schema_version':1,'method':'bounded affine registration of source building footprints to public OSM building polygons','campuses':exported},ensure_ascii=False,indent=2)+'\n',encoding='utf-8',newline='\n')
