# -*- mode: sh; eval: (sh-set-shell "zsh") -*-
#
# @name: kiro
# @brief: Set up environment when running inside AWS's Kiro IDE.
# @repository: https://github.com/johnstonskj/zsh-kiro-plugin
# @version: 0.1.1
# @license: MIT AND Apache-2.0
#

if [[ "${TERM_PROGRAM}" == "kiro" ]]; then
    if command -v kiro >/dev/null 2>&1; then
        source "$(kiro --locate-shell-integration-path zsh)"
    else
        log_error "cannot initialize Kiro shell integrations, it's not on the path"
    fi
fi
