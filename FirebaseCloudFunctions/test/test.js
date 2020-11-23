const assert = require('assert');

const firebase = require('@firebase/rules-unit-testing');

const MY_PROJECT_ID = "";

const myID = "user_me";
const otherID = "user_other";

const myAuth = { uid: myId, };

describe("UnitTest", () => {
    it("Add", () => {
        assert.strictEqual(2+2, 4);
    });
});