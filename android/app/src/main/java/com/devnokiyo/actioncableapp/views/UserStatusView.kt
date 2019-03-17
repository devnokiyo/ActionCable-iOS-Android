package com.devnokiyo.actioncableapp.views

import android.content.Context
import android.graphics.Outline
import android.support.constraint.ConstraintLayout
import android.util.AttributeSet
import android.view.View
import android.view.ViewOutlineProvider
import com.devnokiyo.actioncableapp.R
import kotlinx.android.synthetic.main.view_user_status.view.*
import android.view.animation.Animation
import android.view.animation.TranslateAnimation



class UserStatusView : ConstraintLayout {
    constructor(context: Context) : super(context)
    constructor(context: Context, attrs: AttributeSet) : super(context, attrs)
    constructor(context: Context, attrs: AttributeSet, defStyleAttr: Int) : super(context, attrs, defStyleAttr)

    init {
        View.inflate(context, R.layout.view_user_status, this)

        icon.outlineProvider = object : ViewOutlineProvider() {
            override fun getOutline(view: View, outline: Outline) {
                outline.setRoundRect(
                    0,
                    0,
                    view.width,
                    view.height,
                    view.height / 10f
                )
            }
        }
        icon.clipToOutline = true
        online.outlineProvider = object : ViewOutlineProvider() {
            override fun getOutline(view: View, outline: Outline) {
                outline.setRoundRect(
                    0,
                    0,
                    view.width,
                    view.height,
                    view.height.toFloat()
                )
            }
        }
        online.clipToOutline = true
        icon.viewTreeObserver.addOnGlobalLayoutListener {
            val lp = online.layoutParams
            lp.width = icon.width / 10
            lp.height = icon.height / 10
            online.layoutParams = lp
        }
    }

    fun rockBark() {
        val ta = TranslateAnimation(
            Animation.RELATIVE_TO_SELF, 0.0f,
            Animation.RELATIVE_TO_SELF, 0.2f,
            Animation.RELATIVE_TO_SELF, 0.0f,
            Animation.RELATIVE_TO_SELF, 0.0f
        )

        ta.duration = 100
        ta.repeatCount = 0
        ta.fillAfter = false
        bark.startAnimation(ta)
    }
}