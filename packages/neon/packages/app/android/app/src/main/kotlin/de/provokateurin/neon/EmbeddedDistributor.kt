package de.provokateurin.neon

import android.content.Context
import org.unifiedpush.android.foss_embedded_fcm_distributor.EmbeddedDistributorReceiver

class EmbeddedDistributor: EmbeddedDistributorReceiver() {
    override val googleProjectNumber = "4080759049"

    override fun getEndpoint(context: Context, token: String, instance: String): String {
        return "https://up.proxy.neon.provokateurin.de/FCM?v2&instance=$instance&token=$token"
    }
}
