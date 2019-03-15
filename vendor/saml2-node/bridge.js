var fs = require('fs');
exports.decodeSaml= function(path) {
    return require("./saml2-gateway.js").decodeAuthnResponse(fs.readFileSync(path));
}