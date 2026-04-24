#!/usr/bin/env bash

echo "=============================="
echo "STARTING DEPLOY + UPGRADE FLOW"
echo "=============================="

# -----------------------------
# CONFIG
# -----------------------------
RPC_URL="http://localhost:8545"

# Anvil default keys
DEPLOYER_PK="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
USER_PK="0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d"

# -----------------------------
# STEP 1: DEPLOY
# -----------------------------
echo "🧱 Step 1: Deploying BoxV1 + Proxy..."

DEPLOY_OUTPUT=$(forge script script/DeployBox.s.sol:DeployBox --rpc-url $RPC_URL --private-key $DEPLOYER_PK --broadcast)

# Extract proxy address
PROXY=$(echo "$DEPLOY_OUTPUT" | grep -oP '0: address \K0x[a-fA-F0-9]{40}')

echo "✅ Proxy deployed at: $PROXY"
echo ""

# -----------------------------
# STEP 2: VERIFY VERSION V1
# -----------------------------
echo "🔍 Step 2: Checking version (should be 1)..."

VERSION=$(cast call $PROXY "version()" --rpc-url $RPC_URL)
VERSION_DEC=$(cast --to-dec $VERSION)

echo "📦 Current Version: $VERSION_DEC"
echo ""

# -----------------------------
# STEP 3: UPGRADE
# -----------------------------
echo "⬆️ Step 3: Upgrading to BoxV2..."

forge script script/UpgradeBox.s.sol:UpgradeBox --rpc-url $RPC_URL --private-key $DEPLOYER_PK --broadcast

echo "✅ Upgrade complete"
echo ""

# -----------------------------
# STEP 4: VERIFY VERSION V2
# -----------------------------
echo "🔍 Step 4: Checking version (should be 2)..."

VERSION=$(cast call $PROXY "version()" --rpc-url $RPC_URL)
VERSION_DEC=$(cast --to-dec $VERSION)

echo "📦 Current Version: $VERSION_DEC"
echo ""

# -----------------------------
# STEP 5: INTERACT (setNumber)
# -----------------------------
echo "⚙️ Step 5: Calling setNumber(777)..."

cast send $PROXY "setNumber(uint256)" 777 \
  --rpc-url $RPC_URL \
  --private-key $USER_PK > /dev/null

echo "✅ setNumber executed"
echo ""

# -----------------------------
# STEP 6: READ VALUE
# -----------------------------
echo "📖 Step 6: Reading stored number..."

VALUE=$(cast call $PROXY "getNumber()" --rpc-url $RPC_URL)
VALUE_DEC=$(cast --to-dec $VALUE)

echo "📊 Stored Number: $VALUE_DEC"
echo ""

# -----------------------------
# DONE
# -----------------------------
echo "=============================="
echo "🎉 ALL DONE SUCCESSFULLY"
echo "=============================="