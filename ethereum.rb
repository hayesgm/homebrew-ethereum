require 'formula'

class Ethereum < Formula
  version '1.3.6'

  homepage 'https://github.com/ethereum/go-ethereum'
  url 'https://github.com/ethereum/go-ethereum.git', :branch => 'master'

  bottle do
    revision 13
    root_url 'https://build.ethdev.com/builds/bottles'
    sha256 '45ed53f55fcabe8fa6d215b456dd53c6f0d45a35ac27192efef4ba2c9a448700' => :yosemite
    sha256 'ffd38d656501b54fcc04251fd5f021d6707175ec66aaec9d6eebaa9be5225c72' => :el_capitan
  end

  devel do
    bottle do
      revision 177
      root_url 'https://build.ethdev.com/builds/bottles-dev'
      sha256 '856896d291ffb892bf005d27cb3255e298dd9731e119c0c0764b559c2515e6f5' => :yosemite
      sha256 'fc57893401e104741dfe76e1f8c6f05a730e95f763d4b4a04aa774763ad78d1b' => :el_capitan
    end

    version '1.5.0'
    url 'https://github.com/ethereum/go-ethereum.git', :branch => 'develop'
  end

  depends_on 'go' => :build

  def install
    ENV["GOROOT"] = "#{HOMEBREW_PREFIX}/opt/go/libexec"
    system "go", "env" # Debug env
    system "make", "all"
    bin.install 'build/bin/evm'
    bin.install 'build/bin/geth'
    bin.install 'build/bin/rlpdump'
  end

  test do
    system "make", "test"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ThrottleInterval</key>
        <integer>300</integer>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/geth</string>
            <string>-datadir=#{prefix}/.ethereum</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end
