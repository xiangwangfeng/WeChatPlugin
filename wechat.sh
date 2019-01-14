DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DYLD_INSERT_LIBRARIES=${DIR}/libWeChatPlugin.dylib /Applications/WeChat.app/Contents/MacOS/WeChat &
