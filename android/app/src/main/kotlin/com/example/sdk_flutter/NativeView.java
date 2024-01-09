package com.example.sdk_flutter;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.ContextWrapper;
import android.graphics.Color;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentContainerView;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import com.viafourasdk.src.fragments.base.VFFragment;
import com.viafourasdk.src.fragments.previewcomments.VFPreviewCommentsFragment;
import com.viafourasdk.src.interfaces.VFActionsInterface;
import com.viafourasdk.src.interfaces.VFLayoutInterface;
import com.viafourasdk.src.interfaces.VFLoginInterface;
import com.viafourasdk.src.model.local.VFActionData;
import com.viafourasdk.src.model.local.VFActionType;
import com.viafourasdk.src.model.local.VFArticleMetadata;
import com.viafourasdk.src.model.local.VFColors;
import com.viafourasdk.src.model.local.VFSettings;
import com.viafourasdk.src.model.local.VFSortType;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

class NativeView implements PlatformView {

    private View fragmentContainerView;

    public NativeView(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams, FlutterEngine flutterEngine) {
        MethodChannel heightChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), Constants.HEIGHT_UPDATED);
        MethodChannel authChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), Constants.AUTH_CHANNEL);
        VFArticleMetadata articleMetadata = new VFArticleMetadata((String) creationParams.get("url"), (String) creationParams.get("title"), (String) creationParams.get("description"), (String) creationParams.get("thubmnailUrl"));
        VFColors vfColors = new VFColors(Color.RED, Color.RED);
        VFSettings vfSettings = new VFSettings(vfColors);
        VFPreviewCommentsFragment previewCommentsFragment = VFPreviewCommentsFragment.newInstance((Application) context.getApplicationContext(), "12939123", articleMetadata, new VFLoginInterface() {
            @Override
            public void startLogin() {
                authChannel.invokeMethod("startLogin", null);
            }
        }, vfSettings, 10, VFSortType.mostLiked);
        previewCommentsFragment.setLayoutCallback(new VFLayoutInterface() {
            @Override
            public void containerHeightUpdated(VFFragment fragment, String containerId, int height) {
                heightChannel.invokeMethod("heightUpdated", height);
            }
        });
        previewCommentsFragment.setActionCallback(new VFActionsInterface() {
            @Override
            public void onNewAction(VFActionType actionType, VFActionData action) {
                if(actionType == VFActionType.trendingArticlePressed){
                    authChannel.invokeMethod("articlePressed", action.getTrendingPressedAction().containerId);
                }
            }
        });

        int viewId = View.generateViewId();
        View view = new FragmentContainerView(context);
        view.setId(viewId);

        view.addOnAttachStateChangeListener(new View.OnAttachStateChangeListener() {
            @Override
            public void onViewAttachedToWindow(@NonNull View view) {
                FragmentActivity activity = getFragmentActivityOrThrow(view.getContext());

                if(activity != null){
                    Fragment existingFragment = activity.getSupportFragmentManager().findFragmentByTag("flutter_fragment");
                    if(existingFragment != null){
                        FragmentTransaction fragmentTransaction = existingFragment.getChildFragmentManager().beginTransaction();
                        fragmentTransaction.replace(viewId, previewCommentsFragment);
                        fragmentTransaction.commit();
                    }
                }
            }

            @Override
            public void onViewDetachedFromWindow(@NonNull View view) {

            }
        });

        this.fragmentContainerView = view;
    }

    private FragmentActivity getFragmentActivityOrThrow(Context context) throws IllegalStateException{
        if (context instanceof FragmentActivity) {
            return (FragmentActivity) context;
        }

        Context currentContext = context;
        while (currentContext instanceof ContextWrapper) {
            if (currentContext instanceof FragmentActivity) {
                return (FragmentActivity) currentContext;
            }
            currentContext = ((ContextWrapper) currentContext).getBaseContext();
        }

        throw new IllegalStateException("Unable to find activity");
    }

    @NonNull
    @Override
    public View getView() {
        return fragmentContainerView;
    }

    @Override
    public void dispose() {}
}