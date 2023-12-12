// Language reference:
// https://cadence-lang.org/docs/language/built-in-functions#revertiblerandom
// Run the snippet here: https://academy.ecdao.org/en/snippets/cadence-random
access(all) fun main(): UInt64 {
	// Simple assignment using revertibleRandom - keep reading docs for safe usage!	
	let rand: UInt64 = revertibleRandom()
	return rand
}
