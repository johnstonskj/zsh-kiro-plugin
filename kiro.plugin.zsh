# -*- mode: sh; eval: (sh-set-shell "zsh") -*-
#
# @name kiro
# @description Zsh plugin to set up environment when running in Kiro.
# @repository https://github.com/johnstonskj/zsh-kiro-plugin
#

if [[ "${TERM_PROGRAM}" == "kiro" ]]; then
    if command -v kiro >/dev/null 2>&1; then
        source "$(kiro --locate-shell-integration-path zsh)"
    else
        log_error "cannot initialize Kiro shell integrations, it's not on the path"
    fi
fi
