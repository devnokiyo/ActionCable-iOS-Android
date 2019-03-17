package com.devnokiyo.actioncableapp.activities

import android.graphics.Color
import android.os.Bundle
import android.os.Handler
import android.support.v7.app.AppCompatActivity
import android.util.Log
import android.view.MenuItem
import com.devnokiyo.actioncableapp.R
import com.devnokiyo.actioncableapp.enums.DogName
import com.devnokiyo.actioncableapp.enums.SocketType
import com.devnokiyo.actioncableapp.models.RoomChannelResponse
import com.devnokiyo.actioncableapp.views.UserStatusView
import com.google.gson.JsonObject
import com.hosopy.actioncable.*
import kotlinx.android.synthetic.main.activity_bark.*
import kotlinx.android.synthetic.main.view_user_status.view.*
import java.net.URI


class BarkActivity : AppCompatActivity() {
    private val cableUrl = "ws://devnokiyo.example.com/cable"
    private val channelIdentifier = "RoomChannel"

    private lateinit var client: Consumer
    private lateinit var channel: Subscription

    private lateinit var account: String
    private lateinit var room: String

    private var isSubscribed = false
    private var handler = Handler()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_bark)

        account = intent.getStringExtra(MainActivity.PARAM_ACCOUNT)
        room = intent.getStringExtra(MainActivity.PARAM_ROOM)

        initView()
        initListener()
    }

    override fun onResume() {
        super.onResume()
        initClientAndChannel()
    }

    override fun onPause() {
        super.onPause()
        client.disconnect()
    }

    override fun onOptionsItemSelected(item: MenuItem) = when (item.itemId) {
        android.R.id.home -> {
            finish()
            true
        }
        else -> {
            super.onOptionsItemSelected(item)
        }
    }

    private fun initListener() {
        bawBawButton.setOnClickListener {
            bark(bark = "bawbaw")
        }
        WaooonButton.setOnClickListener {
            bark(bark = "waooon")
        }
        mumblingButton.setOnClickListener {
            subscribedAction { channel.perform("mumbling") }
        }
    }

    private fun initView() {
        toolbar.title = ""
        setSupportActionBar(toolbar)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)

        accountNameLabel.text = getResourceString(account)
        roomNameLabel.text = getResourceString(room)

        chiyoUsv.icon.setImageResource(R.drawable.chiyo)
        chiyoUsv.name.text = getResourceString(DogName.Chiyo.rawValue)
        chiyoUsv.bark.text = getResourceString(SocketType.RoomOut.rawValue)

        eruUsv.icon.setImageResource(R.drawable.eru)
        eruUsv.name.text = getResourceString(DogName.Eru.rawValue)
        eruUsv.bark.text = getResourceString(SocketType.RoomOut.rawValue)

        otomeUsv.icon.setImageResource(R.drawable.otome)
        otomeUsv.name.text = getResourceString(DogName.Otome.rawValue)
        otomeUsv.bark.text = getResourceString(SocketType.RoomOut.rawValue)
    }

    private fun initClientAndChannel() {
        client = ActionCable.createConsumer(URI("$cableUrl/?account=$account"))
        channel = client.subscriptions.create(Channel(channelIdentifier).apply { addParam("room", room) })

        channel.onConnected {
            isSubscribed = true
            channel.perform("greeting")
        }

        channel.onReceived { data ->
            handler.post {
                Log.d("==============", "Received")
                RoomChannelResponse.create(data)?.let { response ->
                    val userStatusView = findUserStatusView(response.account)
                    when (response.type) {
                        SocketType.RoomIn -> {
                            updateUserStatus(accounts = response.roommate, type = response.type)
                            userStatusView.bark.text = getResourceString(response.type.rawValue)
                        }
                        SocketType.RoomOut -> {
                            userStatusView.bark.text = getResourceString(response.type.rawValue)
                            userStatusView.online.setBackgroundColor(Color.RED)
                        }
                        SocketType.Mumbling -> {
                            response.content?.let { content ->
                                userStatusView.bark.text = content
                                userStatusView.rockBark()
                            }
                        }
                        SocketType.Bark -> {
                            response.content?.let { content ->
                                userStatusView.bark.text = getResourceString(content)
                                userStatusView.rockBark()
                            }
                        }
                    }
                }
            }
        }

        client.connect()
    }

    private fun updateUserStatus(accounts: Array<String>?, type: SocketType) {
        accounts?.forEach {
            val usv = findUserStatusView(account = it)
            usv.bark.text = getResourceString(type.rawValue)
            usv.online.setBackgroundColor(Color.GREEN)
        }
    }

    private fun findUserStatusView(account: String?): UserStatusView = when (DogName.create(account!!)) {
        DogName.Chiyo -> chiyoUsv
        DogName.Eru -> eruUsv
        DogName.Otome -> otomeUsv
    }

    private fun bark(bark: String) {
        subscribedAction {
            channel.perform("bark", JsonObject().apply { addProperty("content", bark) })
        }
    }

    private fun subscribedAction(action: () -> Unit) {
        if (isSubscribed) {
            action()
        }
    }

    private fun getResourceString(name: String): String =
        getString(resources.getIdentifier(name, "string", packageName))
}
