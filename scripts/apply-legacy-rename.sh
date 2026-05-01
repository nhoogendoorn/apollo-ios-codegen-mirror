#!/usr/bin/env bash
# Replays the `_Legacy` rename onto a clean checkout of an upstream
# apollo-ios-codegen tag. Run from the repo root immediately after
# branching from the new upstream tag.
#
#   git checkout -b apollo/stable-<NEW>-revision-1 <NEW>
#   ./scripts/apply-legacy-rename.sh
#
# After this script: also update Package.swift, cherry-pick the small
# Legacy fix commits (cocoapods literals + public targetName), and bump
# the two Constants.swift version strings.

set -euo pipefail

if [ ! -f Package.swift ]; then
  echo "error: run from the repo root" >&2
  exit 1
fi

# 1. Rename source folders.
git mv Sources/ApolloCodegenLib   Sources/ApolloCodegenLib_Legacy
git mv Sources/CodegenCLI         Sources/CodegenCLI_Legacy
git mv Sources/GraphQLCompiler    Sources/GraphQLCompiler_Legacy
git mv Sources/IR                 Sources/IR_Legacy
git mv Sources/TemplateString     Sources/TemplateString_Legacy
git mv Sources/Utilities          Sources/Utilities_Legacy
git mv Sources/apollo-ios-cli     Sources/apollo-ios-cli-legacy

# 2. Rewrite Swift imports + qualified type refs to the renamed modules.
#    macOS sed -i needs the '' arg.
find Sources -type f -name '*.swift' -print0 | xargs -0 sed -i '' \
  -e 's/^import ApolloCodegenLib$/import ApolloCodegenLib_Legacy/' \
  -e 's/^import CodegenCLI$/import CodegenCLI_Legacy/' \
  -e 's/^import GraphQLCompiler$/import GraphQLCompiler_Legacy/' \
  -e 's/^import IR$/import IR_Legacy/' \
  -e 's/^import TemplateString$/import TemplateString_Legacy/' \
  -e 's/^import Utilities$/import Utilities_Legacy/' \
  -e 's/\([^A-Za-z0-9_]\)IR\./\1IR_Legacy./g' \
  -e 's/\([^A-Za-z0-9_]\)GraphQLCompiler\./\1GraphQLCompiler_Legacy./g' \
  -e 's/\([^A-Za-z0-9_]\)CodegenCLI\./\1CodegenCLI_Legacy./g'

# NOTE: do not rewrite `TemplateString.` — `TemplateString` is also a public
# struct (with nested `StringInterpolation`), so `.` after it is a type
# member access, not a module prefix.

# 3. Rewrite TS namespace refs in the JS compiler bridge.
find Sources/GraphQLCompiler_Legacy/JavaScript/src -type f \
  \( -name '*.ts' -o -name '*.js' \) -print0 | xargs -0 sed -i '' \
  -e 's/\([^A-Za-z0-9_]\)IR\./\1IR_Legacy./g'

# 4. Drop the JS package-lock.json (the fork doesn't track it).
git rm -f Sources/GraphQLCompiler_Legacy/JavaScript/package-lock.json 2>/dev/null || true

echo "rename complete. next:"
echo "  - update Package.swift to use the _Legacy target/product names"
echo "  - cherry-pick the cocoapods-literal + public-targetName fix commits"
echo "  - bump CodegenVersion + CLIVersion in Constants.swift"
