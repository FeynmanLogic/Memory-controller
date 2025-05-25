

# 🔧 Verilog Memory Controller with Direct-Mapped Cache and LRU Replacement

Author: **Dhruv Kulkarni**
Refined with AI assistance ✨

## 📝 Overview

This project implements a **Verilog-based memory controller** with a **direct-mapped cache** structure and an **LRU-inspired replacement policy**. The goal was to simulate a basic cache that supports both read and write operations without relying on dynamic memory structures—making it fully synthesizable.

## 📦 Features

* ✅ **Direct-Mapped Cache**
  Uses the lower 5 bits of the address for indexing into a 32-line cache.

* ✅ **LRU Replacement Policy (Simulated)**
  When the cache is full, the **least recently used** entry is identified using a `cache_indexes[]` pseudo-counter array and replaced.

* ✅ **No Dynamic Data Structures**
  All memory and counters are implemented with fixed-size arrays to keep the design lean and hardware-friendly.

* ✅ **Write-through Memory Updates**
  Every write updates both main memory and the cache.

* ✅ **Simple Testbench Included**
  Demonstrates basic write and read operations.

## ⚙️ Modules

### `memory_controller`

* Inputs: `clk`, `memory_val`, `address`, `read`, `write`
* Output: `value`
* Internal:

  * `memory_bank[1024]` – Main memory
  * `cache_data[32]` – Cache lines
  * `cache_valid[32]` – Validity bits
  * `cache_indexes[32]` – Pseudo-counter for LRU tracking

### `testbench`

* Simulates basic cache read/write
* Can be expanded to test eviction logic (e.g., fill all 32 entries, then access another)

## ❓ Motivation

The motivation behind using `cache_indexes[]` as a pseudo-counter is to simulate LRU without using dynamic arrays or complex linked structures. This keeps the hardware **synthesizable** and avoids unnecessary overhead.

> 💡 **Fun Fact**: Verilog doesn’t support `break` statements in loops—because we’re designing hardware, not software! Control flow must be fully deterministic and synthesizable.

## 🧠 Possible Extensions

* Add support for **set-associative** caches
* Support **block sizes > 1 word**
* Implement **cache flushing** on reset
* Add **cache hit/miss statistics** for performance analysis

## ❓ Can We Reduce Space Further?

Yes! While this current implementation uses a `cache_indexes[32]` array for LRU logic, more space-efficient options include:

* Using **smaller-width counters** (e.g., 4–5 bits instead of 32) if wrap-around behavior is acceptable.
* Implementing **random replacement** (lower performance but very lean).
* Using **PLRU (Pseudo-LRU)** trees for n-way set associative caches if upgrading from direct-mapped.

---
