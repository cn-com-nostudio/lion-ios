export PATH="$PATH:/opt/homebrew/bin"
if which swiftlint > /dev/null; then
    # running swiftlint only on modified files 
    git status --porcelain | grep -v '^ \?D' | cut -c 4- | sed 's/.* -> //' | tr -d '"' | while read file 
    do
        if [[ "$file" == *.swift ]]; then
            swiftlint "$file"
        fi
    done
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi


