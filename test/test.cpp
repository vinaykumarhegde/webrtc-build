#include <assert.h>
#include <iostream>
#include <memory>

#include <webrtc/api/peerconnectioninterface.h>
#include <webrtc/media/base/videosourceinterface.h>


int main(int argc, char **argv) {
    std::unique_ptr<rtc::Thread> network_thd = rtc::Thread::CreateWithSocketServer();
    network_thd->SetName("network_thread", nullptr);
    if (!network_thd->Start()) {
        std::cerr << "network thread failed to start\n";
        return 1;
    }

    std::unique_ptr<rtc::Thread> worker_thd = rtc::Thread::Create();
    worker_thd->SetName("worker_thread", NULL);
    if (!worker_thd->Start()) {
        std::cerr << "worker thread failed to start\n";
        return 1;
    }

    std::unique_ptr<rtc::Thread> signaling_thd = rtc::Thread::Create();
    signaling_thd->SetName("signaling_thread", NULL);
    if (!signaling_thd->Start()) {
        std::cerr << "signaling thread failed to start\n";
        return 1;
    }

    rtc::scoped_refptr<webrtc::PeerConnectionFactoryInterface> pc_factory;
    pc_factory = webrtc::CreatePeerConnectionFactory(
        network_thd.get(),
        worker_thd.get(),
        signaling_thd.get(),
        NULL,
        NULL,
        NULL
    );
    if (!pc_factory.get()) {
        std::cerr << "peer-connection factory create failed\n";
        return 1;
    }

    return 0;
}
