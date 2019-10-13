import { encryptMessage, decryptMessage, generateKey, getIV } from '../../src/security/AES'

describe("AES", () => {
    test("is encrypting", () => {
        expect(encryptMessage("msg", "id")).toBeDefined()
        // This method cannot be tested properly because it has random elements
    }),
    test("is generating key", () => {
        // the result for generating a key with id "thisIsAnExampleString"
        const result = "90b8e4818c630b5e84ab377d84adb794"
        expect(generateKey("thisIsAnExampleString")).toBe(result)
    }),
    test("is decrypting", () => {
        const msg = "This is a result msg"
        const id = "id"
        // encrypt the message and compare the result
        const msgEncrypted = encryptMessage(msg, id)
        expect(decryptMessage(msgEncrypted, id)).toBe(msg)
    }),
    test("gets the right IV", () => {
        // encrypt the message
        const msgEncrypted = encryptMessage("msg", "id")
        // An IV should be always 32 lengths
        const IV = getIV(msgEncrypted)
        expect(IV).toHaveLength(32)
    });
})