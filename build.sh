#!/bin/bash

source ~/.bashrc

CURRENT_DIR=$(
   cd "$(dirname "$0")"
   pwd
)

function env() {
    set -a
    source ${CURRENT_DIR}/build.conf
    set +a
}

function log() {
   message="[Plugin-Build Log]: $1 "
   echo -e "${message}" 2>&1 | tee -a ${CURRENT_DIR}/build.log
}

## 封tar包
function tar_package() {
    log "打包插件..."
    cd ${CURRENT_DIR}
    plugin_root=${CURRENT_DIR}/$1
    package_name=$(grep '"package_name"' ${plugin_root}/index.json | awk -F '"' '{print $4}')
    package_name=${package_name//./-}
    log "开始打包插件：${package_name}"
    chmod -R 777 ${plugin_root}
    cd ${plugin_root}
    if [[ $(uname -s) == "Darwin" ]]; then
        # mac下建议使用gtar，避免在linux上解压提示未知头的警告
        gtar zcvf ${CURRENT_DIR}/${package_name}.tar.gz *
    elif [[ $(uname -s) == "Linux" ]]; then
        tar zcvf ${CURRENT_DIR}/${package_name}.tar.gz *
    fi
    cd ${CURRENT_DIR}
    log "打包完成..."
}

main() {
    # 检查参数数量
    if [ $# -eq 0 ]; then
        echo "错误：必须提供打包root参数，示例：$0 plugin-root"
        echo "用法：$0 参数1 [参数2 ...]"
        exit 1
    fi
    env
    # 循环遍历所有参数
    for arg in "$@"; do
      tar_package $arg
    done
}


main "${@}"