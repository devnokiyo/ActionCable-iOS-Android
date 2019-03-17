package com.devnokiyo.actioncableapp.enums


enum class DogName(val rawValue: String) {
    Chiyo("chiyo"),
    Eru("eru"),
    Otome("otome");

    fun capitalized(): String {
        return rawValue.capitalize()
    }

    companion object {
        var accounts: Array<String> = arrayOf()
            get() = arrayOf(DogName.Chiyo.rawValue, DogName.Eru.rawValue, DogName.Otome.rawValue)

        fun create(rawValue: String): DogName {
            return values().first { it.rawValue == rawValue }
        }
    }
}
