package com.devnokiyo.actioncableapp.enums

import com.google.gson.annotations.SerializedName


enum class SocketType(val rawValue: String) {
    @SerializedName("in")
    RoomIn("in"),
    @SerializedName("out")
    RoomOut("out"),
    @SerializedName("mumbling")
    Mumbling("mumbling"),
    @SerializedName("bark")
    Bark("bark")
}
