# Foundry Proxy Upgradeable Contract

A minimal, hands-on project demonstrating **upgradeable smart contracts** using the **UUPS proxy pattern** with Foundry.

This repo walks you through:

* Deploying an implementation contract (`BoxV1`)
* Deploying a proxy (`ERC1967Proxy`)
* Interacting through the proxy
* Upgrading to a new implementation (`BoxV2`)
* Verifying state persistence after upgrade

---

## Project Structure

```
├── src/
│   ├── BoxV1.sol
│   ├── BoxV2.sol
│
├── script/
│   ├── DeployBox.s.sol
│   ├── UpgradeBox.s.sol
│
├── test/
│   ├── DeployAndUpgradeTest.t.sol
│
├── script.sh   <-- Your automation script
```

---

## Quickstart (Step-by-Step)

### 1. Clone Repo

```
git clone https://github.com/Nuelonye/Foundry-Proxy-Upgradeable-Contract
cd foundry-proxy-upgradeable-contract
```

### 2. Install Dependencies

```bash
forge install
```

---

### 3. Start Local Blockchain (Anvil)

```bash
anvil
```

Keep this running.

---

### 4. Make Script Executable

```bash
chmod +x deploy_and_upgrade.sh
```

---

### 5. Run Full Flow

```bash
./deploy_and_upgrade.sh
```

This will:

1. Deploy `BoxV1`
2. Deploy `ERC1967Proxy`
3. Initialize contract
4. Check version (should be 1)
5. Upgrade to `BoxV2`
6. Check version (should be 2)
7. Call `setNumber(777)`
8. Read stored value

---

## ✅ Expected Output Summary

After running:

```
Version: 1
Upgrade...
Version: 2
Stored Number: 777
```

# Thank You!
