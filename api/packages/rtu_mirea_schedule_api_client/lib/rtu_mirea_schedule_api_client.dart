/// A package that provides access to the remote schedule API of the RTU MIREA
library rtu_mirea_schedule_api_client;

export 'src/campuses.dart';
export 'src/fields_data_parsers.dart';
export 'src/ical_parser.dart'
    show EventDatesAndTime, ICalParser, ICalendarParsingException, InvalidICalendarDataException;
export 'src/models/models.dart';
export 'src/rtu_mirea_schedule_api_client.dart';
