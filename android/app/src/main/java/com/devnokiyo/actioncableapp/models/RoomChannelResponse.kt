package com.devnokiyo.actioncableapp.models

import com.devnokiyo.actioncableapp.enums.SocketType
import com.google.gson.Gson
import com.google.gson.JsonElement

data class RoomChannelResponse(
    val account: String,
    val roommate: Array<String>?,
    val type: SocketType,
    val content: String?
) {

    companion object {
        fun create(data: JsonElement): RoomChannelResponse? =
            try {
                Gson().fromJson<RoomChannelResponse>(data, RoomChannelResponse::class.java)
            } catch (e: Exception) {
                null
            }
    }
}