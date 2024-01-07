package com.example.sdk_flutter;

import android.app.Application;
import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.viafourasdk.src.fragments.base.VFFragment;
import com.viafourasdk.src.fragments.previewcomments.VFPreviewCommentsFragment;
import com.viafourasdk.src.interfaces.VFLayoutInterface;
import com.viafourasdk.src.interfaces.VFLoginInterface;
import com.viafourasdk.src.model.local.VFArticleMetadata;
import com.viafourasdk.src.model.local.VFColors;
import com.viafourasdk.src.model.local.VFSettings;
import com.viafourasdk.src.model.local.VFSortType;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.Map;

import io.flutter.plugin.platform.PlatformView;

class NativeView implements PlatformView {
    @NonNull
    private final VFPreviewCommentsFragment previewCommentsFragment;

    NativeView(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams) {
        VFArticleMetadata articleMetadata = null;
        try {
            articleMetadata = new VFArticleMetadata(new URL("https://test.com"), "", "", new URL("https://test.com"));
        } catch (MalformedURLException e) {
            throw new RuntimeException(e);
        }
        VFColors vfColors = new VFColors(Color.RED, Color.RED);
        VFSettings vfSettings = new VFSettings(vfColors);
        previewCommentsFragment = VFPreviewCommentsFragment.newInstance((Application) context.getApplicationContext(), "", articleMetadata, new VFLoginInterface() {
            @Override
            public void startLogin() {

            }
        }, vfSettings, 10, VFSortType.mostLiked);
        previewCommentsFragment.setLayoutCallback(new VFLayoutInterface() {
            @Override
            public void containerHeightUpdated(VFFragment fragment, String containerId, int height) {

            }
        });
    }

    @NonNull
    @Override
    public View getView() {
        return previewCommentsFragment.getView();
    }

    @Override
    public void dispose() {}
}