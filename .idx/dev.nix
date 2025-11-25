{ pkgs, ... }:

{
  # Use the latest stable nixpkgs (24.05 is fine, 24.11 is newer)
  channel = "stable-24.11";  # or "unstable" if you want bleeding edge

  # Packages available in the shell
  packages = [
    pkgs.git
    pkgs.wget
    pkgs.unzip
    pkgs.jdk17           # Required for Gradle 8.6+
    pkgs.gradle          # Will pull Gradle 8.11+ automatically
    pkgs.android-tools   # Includes adb, fastboot, etc.
  ];

  # Android-specific setup
  env = {
    # Tell Gradle to use our JDK 17 (very important!)
    JAVA_HOME = "${pkgs.jdk17}";

    # Android SDK setup
    ANDROID_HOME   = "/opt/android-sdk";
    ANDROID_SDK_ROOT = "/opt/android-sdk";

    # Add Android tools to PATH
    PATH = "$PATH:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools";
  };

  # Install Android SDK + common tools on workspace creation
  idx = {
    extensions = [
      "vscjava.vscode-java-pack"
      "vscjava.vscode-gradle"
      "esbenp.prettier-vscode"   # optional, if you have web/JS code too
    ];

    previews = {
      enable = true;
      previews = {
        # Example for React Native / Expo (remove if not needed)
        # web = {
        #   command = [ "npm" "start" ];
        #   manager = "web";
        #   env = { PORT = "$PORT"; };
        # };
      };
    };

    workspace = {
      onCreate = {
        # Install Android command line tools + accept licenses
        install-android-sdk = ''
          mkdir -p /opt/android-sdk/cmdline-tools
          wget -q https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip -O cmdline-tools.zip
          unzip -q cmdline-tools.zip -d /opt/android-sdk/cmdline-tools
          mv /opt/android-sdk/cmdline-tools/cmdline-tools /opt/android-sdk/cmdline-tools/latest
          rm cmdline-tools.zip

          # Accept all licenses
          yes | sdkmanager --licenses

          # Install essential packages (adjust versions as needed)
          sdkmanager \
            "platform-tools" \
            "platforms;android-34" \
            "build-tools;34.0.0" \
            "cmdline-tools;latest" \
            "cmake;10.0.2" \
            "ndk;26.1.10909125"
        '';
      };

      onStart = {
        # Optional: print helpful info when you open the terminal
        welcome = ''
          echo "Android dev environment ready!"
          echo "JAVA_HOME: $JAVA_HOME"
          echo "Gradle: $(gradle --version | grep Gradle)"
          echo "Android SDK: $ANDROID_HOME"
          echo "Run './gradlew tasks' to see available tasks"
        '';
      };
    };
  };
}