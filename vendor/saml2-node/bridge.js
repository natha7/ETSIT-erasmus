var fs = require('fs');
exports.decodeSaml= function(path) {
    require("./saml2-gateway.js").decodeAuthnResponse(fs.readFileSync(path))
}