#!/bin/bash

COLOR_CYAN='\033[0;36m'
COLOR_GREEN='\033[0;32m'
COLOR_RED='\033[0;31m'
COLOR_YELLOW='\033[1;33m'
COLOR_NC='\033[0m'

APK_PATH="build/app/outputs/apk/release/"

execute_step() {
    echo -e "${COLOR_YELLOW}--> $1${COLOR_NC}"
    eval "$2"

    # 获取上一个命令的退出状态码
    local status=$?

    # 如果状态码不为 0 (表示命令失败)
    if [ $status -ne 0 ]; then
        echo ""
        echo -e "${COLOR_RED} [失败]'$1' 状态码: $status ${COLOR_NC}"
        # 脚本异常退出
        exit $status
    else
        echo -e "${COLOR_GREEN} [成功]'$1' 已完成。${COLOR_NC}"
        echo ""
    fi
}

# 默认的 Flutter 命令执行器
FLUTTER_CMD="flutter"

check_fvm(){
  if command -v fvm &> /dev/null; then
      echo -e "${COLOR_CYAN}==>> 系统已安装FVM。正在检查项目配置...${COLOR_NC}"
      if [ -d ".fvm" ]; then
          echo -e "${COLOR_GREEN}==>> 项目已配置FVM。将使用 'fvm flutter'。${COLOR_NC}"
          FLUTTER_CMD="fvm flutter"
          execute_step "使用 FVM 切换到项目版本" "fvm use"
      else
          echo -e "${COLOR_YELLOW}==>>未检测到FVM环境。将使用 Flutter命令。${COLOR_NC}"
      fi
  else
      echo -e "${COLOR_CYAN}==>> 未检测到FVM环境。将使用 Flutter命令。${COLOR_NC}"
  fi
}

echo ""

do_version(){
  execute_step "显示当前使用的 Flutter 版本" "${FLUTTER_CMD} --version"
}
do_clean(){
  echo "--- 清理项目缓存 ---"
  execute_step "执行 Clean" "${FLUTTER_CMD} clean"
}
do_get(){
  echo "--- 获取依赖包 ---"
  execute_step "执行 pub get" "${FLUTTER_CMD} pub get"
}
do_build(){
  execute_step "执行 pub run build_runner" "${FLUTTER_CMD} pub run build_runner build --delete-conflicting-outputs"
}

do_plugin(){
  local  final_args=${ARGS:-"native_plugin"}
  execute_step "执行构建插件操作" "${FLUTTER_CMD}  create --template=plugin --platforms=android,ios $final_args"
}

do_dart(){
  local  final_args=${ARGS:-"native_util"}
  execute_step "执行构建Dart包操作" "dart create --template=package $final_args"
}

do_flutter(){
  local  final_args=${ARGS:-"native_flutter"}
  execute_step "执行构建Flutter包操作" "${FLUTTER_CMD}  create --template=package $final_args"
}

do_apk(){
  echo "--- 构建 Release 版本 ---"
  execute_step  "build apk" "${FLUTTER_CMD} build apk --release"
  do_open
  exit 0
}

do_gray_apk(){
    echo "--- 构建 GrayRelease 版本 ---"
    execute_step  "build gray apk" '${FLUTTER_CMD} build apk --release --dart-define="APP_ENV=gray"'
    do_open
    exit 0
}

do_analyze_apk(){
    echo "--- 构建 分析包 ---"
    local log_file="build_analyze.log"
    execute_step  "build analyze apk" "${FLUTTER_CMD} build apk --release --analyze-size --target-platform android-arm64 | tee $log_file"
    local devtools_cmd=$(grep "dart devtools --appSizeBase=" "$log_file" | tail -n 1 | sed 's/\\/\//g')
    rm -f "$log_file"
    if [ -n "$devtools_cmd" ]; then
            echo -e "${COLOR_GREEN} 成功提取到分析命令，正在自动启动 DevTools...${COLOR_NC}"
            echo -e "${COLOR_YELLOW}执行命令: $devtools_cmd${COLOR_NC}"
            echo ""
            eval "$devtools_cmd"
    else
            echo -e "${COLOR_RED} 未能在日志中找到 DevTools 启动命令，请检查上方日志。${COLOR_NC}"
    fi

    exit 0
}

do_open(){
  if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    local win_path=$(cygpath -w "$APK_PATH")
      explorer.exe "$win_path"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
      open "$APK_PATH"
  else
      xdg-open "$APK_PATH" || echo "请手动前往 $APK_PATH 查看 APK"
  fi
}

do_base(){
      check_fvm
      do_version
      do_clean
      do_get
      do_build
}

MODE=$1
ARGS=$2
if [ "$MODE" == "build" ]; then
    check_fvm
    do_build
    echo -e "${COLOR_GREEN}>>> 构建完成 <<<${COLOR_NC}"
elif [ "$MODE" == "reBuild" ] ; then
    do_base
    echo -e "${COLOR_GREEN}>>> 重新构建完成 <<<${COLOR_NC}"
elif [ "$MODE" == "plugin" ]; then
    do_plugin
    echo -e "${COLOR_GREEN}>>> 构建插件完成 <<<${COLOR_NC}"
elif [ "$MODE" == "dart" ]; then
    do_dart
    echo -e "${COLOR_GREEN}>>> 构建Dart包完成 <<<${COLOR_NC}"
elif [ "$MODE" == "flutter" ]; then
    do_flutter
    echo -e "${COLOR_GREEN}>>> 构建Flutter包完成 <<<${COLOR_NC}"
elif [ "$MODE" == "gray" ] ; then
    do_base
    do_gray_apk
    echo -e "${COLOR_GREEN}>>> GrayRelease打包完成 <<<${COLOR_NC}"
elif [ "$MODE" == "analyze" ] ; then
    do_base
    do_analyze_apk
    echo -e "${COLOR_GREEN}>>> 分析包打包完成 直接运行显示的命名 <<<${COLOR_NC}"
else
   do_base
   do_apk
   echo -e "${COLOR_GREEN}>>> Release打包完成 <<<${COLOR_NC}"
 fi






