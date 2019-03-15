var fs = require('fs');
exports.decodeSaml= function(path) {
    var content = fs.readFileSync(path, "utf8");
    return require("./saml2-gateway.js").decodeAuthnResponse(content);
}