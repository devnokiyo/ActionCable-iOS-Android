package com.devnokiyo.actioncableapp.activities

import android.content.Intent
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.widget.RadioButton
import com.devnokiyo.actioncableapp.R
import com.devnokiyo.actioncableapp.enums.DogName
import com.devnokiyo.actioncableapp.enums.RoomName
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {
    private val accounts = DogName.accounts
    private val rooms = RoomName.rooms

    companion object {
        const val PARAM_ACCOUNT = "account"
        const val PARAM_ROOM = "room"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        initListener()
    }

    private fun initListener() {
        subscribeButton.setOnClickListener {
            val intent = Intent(application, BarkActivity::class.java)
            val account = accounts[getIntTag(accountSg.checkedRadioButtonId)]
            val room = rooms[getIntTag(roomSg.checkedRadioButtonId)]
            intent.putExtra("account", account)
            intent.putExtra("room", room)
            startActivity(intent)
        }
    }

    private fun getIntTag(id: Int): Int {
        val rb = findViewById<RadioButton>(id)
        return rb.tag.toString().toInt()
    }
}
