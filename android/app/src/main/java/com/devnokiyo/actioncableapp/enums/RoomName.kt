package com.devnokiyo.actioncableapp.enums


enum class RoomName(val rawValue: String) {
    Tuna("tuna"),
    Egg("egg"),
    SalmonRoe("salmon_roe");

    companion object {
        var rooms: Array<String> = arrayOf()
            get() = arrayOf(RoomName.Tuna.rawValue, RoomName.Egg.rawValue, RoomName.SalmonRoe.rawValue)
    }
}
