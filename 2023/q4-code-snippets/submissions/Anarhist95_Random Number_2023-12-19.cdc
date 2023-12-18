// gets a number between min & max
pub fun main(min: UInt64, max: UInt64): UInt64 {
  let randomNumber: UInt64 = revertibleRandom()
  return (randomNumber % (max + 1 - min)) + min
}
