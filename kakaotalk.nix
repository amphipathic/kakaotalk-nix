{ lib
, wine
, fetchurl
, fetchzip
, mkWindowsApp
, makeDesktopItem 
, makeDesktopIcon
, copyDesktopItems
, copyDesktopIcons 
}:
mkWindowsApp rec {
  inherit wine; 

  pname = "kakaotalk";
  version = "25.4.1";

  src = fetchurl {
    url = "https://app-pc.kakaocdn.net/talk/win32/x64/KakaoTalk_Setup.exe";
    hash = "sha256-S1N3elSf8m+cQnkeZSTkf/TwosYIcisUBKMhDXrqPEU=";
  };

  font = fetchzip {
    url = "https://hangeul.naver.com/hangeul_static/webfont/zips/nanum-gothic.zip";
    downloadToTemp = true;
    hash = "sha256-dnwxiR6OtcV2PsWzSmCz2Of8Y1gPunFCBd8bjFdoSo8=";
  };

  enableMonoBootPrompt = false;
  dontUnpack = true;
  wineArch = "win64";

  nativeBuildInputs = [ copyDesktopItems copyDesktopIcons ];

  winAppInstall = ''
    cp ${font}/* "$WINEPREFIX/drive_c/windows/Fonts"

    wine ${src} /S 
    wineserver -w 
  '';

  winAppRun = ''
    wine "$WINEPREFIX/drive_c/Program Files/Kakao/KakaoTalk/KakaoTalk.exe"
  '';

  installPhase = ''
    runHook preInstall

    ln -s $out/bin/.launcher $out/bin/${pname}

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      desktopName = "KakaoTalk";
      categories = ["Network" "Chat"];
    })
  ];

  desktopIcon = makeDesktopIcon {
    name = "kakaotalk";
    
    src = fetchurl {
      url = "https://t1.kakaocdn.net/kakaocorp/kakaocorp/admin/service/453a624d017900001.png";
      hash = "sha256-1RTNnl3GN84RhvWLjud5RNdHUu88CwsSyfNrko8IqCs=";
    };
  };

  meta = with lib; {
    homepage = "https://www.kakaocorp.com/page/service/service/KakaoTalk";
    description = "A mobile messaging app for smartphones operated by Kakao Corporation in South Korea";
    license = licenses.unfree;
    maintainers = with maintainers; [ amphipathic ];
    platforms = [ "x86_64-linux" ];
  };
}
