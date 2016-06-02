#include <assert.h>
#include <iostream>

#include <talk/app/webrtc/peerconnectioninterface.h>
#include <talk/app/webrtc/videosourceinterface.h>
#include <talk/media/webrtc/webrtcvideoencoderfactory.h>
#include <talk/media/webrtc/webrtcvideodecoderfactory.h>


int main(int argc, char **argv) {
    rtc::scoped_ptr<rtc::Thread> worker_thd(new rtc::Thread());
    worker_thd->SetName("worker_thread", NULL);
    if (!worker_thd->Start()) {
        std::cerr << "worker thread failed to start\n";
        return 1;
    }

    rtc::scoped_ptr<rtc::Thread> signaling_thd(new rtc::Thread());
    signaling_thd->SetName("signaling_thread", NULL);
    if (!signaling_thd->Start()) {
        std::cerr << "signaling thread failed to start\n";
        return 1;
    }

    rtc::scoped_refptr<webrtc::PeerConnectionFactoryInterface> pc_factory;
    rtc::scoped_ptr<cricket::WebRtcVideoEncoderFactory> encoder_factory;
    rtc::scoped_ptr<cricket::WebRtcVideoDecoderFactory> decoder_factory;
    pc_factory = webrtc::CreatePeerConnectionFactory(
        worker_thd.get(),
        signaling_thd.get(),
        NULL,
        encoder_factory.release(),
        decoder_factory.release()
    );
    if (!pc_factory.get()) {
        std::cerr << "peer-connection factory create failed\n";
        return 1;
    }

    return 0;
}
