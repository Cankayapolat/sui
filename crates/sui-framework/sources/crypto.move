// Copyright (c) 2022, Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

/// Library for cryptography onchain.
module sui::crypto {
    /// @param signature: A 65-bytes signature in form (r, s, v) that is signed using 
    /// Secp256k1. Reference implementation on signature generation using RFC6979: 
    /// https://github.com/MystenLabs/narwhal/blob/5d6f6df8ccee94446ff88786c0dbbc98be7cfc09/crypto/src/secp256k1.rs
    /// 
    /// @param hashed_msg: the hashed 32-bytes message. The message must be hashed instead 
    /// of plain text to be secure.
    /// 
    /// If the signature is valid, return the corresponding recovered Secpk256k1 public 
    /// key, otherwise throw error. This is similar to ecrecover in Ethereum, can only be 
    /// applied to Secp256k1 signatures.
    public native fun ecrecover(signature: vector<u8>, hashed_msg: vector<u8>): vector<u8>;

    /// @param data: arbitrary bytes data to hash
    /// Hash the input bytes using keccak256 and returns 32 bytes.
    public native fun keccak256(data: vector<u8>): vector<u8>;

    /// @param signature: A 48-bytes signature that is a point on the G1 subgroup
    /// @param public_key: A 96-bytes public key that is a point on the G2 subgroup
    /// @param msg: The message that we test the signature against.
    ///
    /// If the signature is a valid BLS12381 signature of the message and public key, return true.
    /// Otherwise, return false.
    public native fun bls12381_verify_g1_sig(signature: vector<u8>, public_key: vector<u8>, msg: vector<u8>): bool; 

    use sui::elliptic_curve::{Self as ec, RistrettoPoint};

    native fun native_verify_full_range_proof(proof: vector<u8>, commitment: vector<u8>);

    /// @param proof: The bulletproof
    /// @param commitment: The commitment which we are trying to verify the range proof for
    /// 
    /// If the range proof is valid, execution succeeds, else panics.
    public fun verify_full_range_proof(proof: vector<u8>, commitment: RistrettoPoint) {
        native_verify_full_range_proof(proof, ec::bytes(&commitment))
    }
}
