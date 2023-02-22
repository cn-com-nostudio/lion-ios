if [ "${CONFIGURATION}" = "Release" ]; then
    # Refer to: https://developer.apple.com/library/archive/qa/qa1827/_index.html
    xcrun agvtool next-version -all
    # xcrun agvtool new-version -all "5"
    # xcrun agvtool new-version -all `date "+%Y%m%d-%H%M%S"`
fi
