var saml2 = require('./saml2');
var eidas = require('./eidas');
var requested_attributes = require('./requested_attributes');
var fs = require('fs');

var idp_options = {
    sso_login_url: eidas.idp_host,
    sso_logout_url: "https://"+eidas.gateway_host+"/users/eidas/logout",
    certificates: []
};
var idp = new saml2.IdentityProvider(idp_options);

var organization = {
    name: eidas.organization.name,
    url: eidas.organization.url,
    nif: "EIDAS-ERASMUS"
};

var contact = {
    support: {
        company: eidas.support.company,
        name: eidas.support.name,
        surname: eidas.support.surname,
        email: eidas.support.email,
        telephone_number: eidas.support.telephone_number
    },
    technical: {
        company: eidas.technical.company,
        name: eidas.technical.name,
        surname: eidas.technical.surname,
        email: eidas.technical.email,
        telephone_number: eidas.technical.telephone_number
    }
};


var sp_options = {
    entity_id: "https://"+ eidas.gateway_host +"/users/eidas/metadata",
    private_key: fs.readFileSync(__dirname +"/../certs/key.pem").toString(),
    certificate: fs.readFileSync(__dirname +"/../certs/cert.pem").toString(),
    assert_endpoint: "https://"+eidas.gateway_host+"/users/eidas/auth",
    audience: "https://"+eidas.gateway_host+"/users/eidas/metadata",
    sign_get_request: true,
    nameid_format: "urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified",
    provider_name: organization.nif,
    auth_context: { comparison: "minimum", AuthnContextClassRef: ["http://eidas.europa.eu/LoA/low"] },
    force_authn: true,
    organization: organization,
    contact: contact,
    valid_until: 60 * 60 * 24 * 365,
    sp_type: "public"
};

var sp = new saml2.ServiceProvider(sp_options);

exports.getMetadata = function() {
    process.stdout.write(sp.create_metadata());
};

exports.decodeAuthnResponse = function(samlResponse){
    sp.post_assert(idp, {request_body: {"SAMLResponse": samlResponse, "RelayState": "MyRelayState"}}, function(err, saml_response){
        var final_response = saml_response;
        var attributes = final_response.user.attributes;
        var mapped_attributes = {};
        Object.keys(attributes).forEach( element =>{
            mapped_attributes = {...mapped_attributes, ...{[element]: attributes[element][0]}}
        });
        process.stdout.write(JSON.stringify(mapped_attributes));
    });
};

exports.getAuthnRequest = function(){
    var array_natural = ["PersonIdentifier" , "FamilyName", "FirstName", "DateOfBirth", "PlaceOfBirth", "CurrentAddress", "Gender","CurrentPhoto", "Nationality", "Phone", "CurrentDegree", "Degree", "DegreeAwardingInstitution", "DegreeCountry", "FieldOfStudy", "GraduationYear", "LanguageCertificates", "LanguageProficiency", "HomeInstitutionAddress", "HomeInstitutionCountry", "HomeInstitutionName", "TemporaryAddress"];
    var array_legal = ["LegalPersonIdentifier", "LegalName"];
    var array_representative = [];

    var extensions = {
        'eidas:SPType': "public",
        'eidas:RequestedAttributes': []
    }


    for (var i=0; i < array_natural.length; i++) {
        extensions['eidas:RequestedAttributes'].push({
            'eidas:RequestedAttribute': requested_attributes.NaturalPerson[array_natural[i]]
        })
    }

    for (var i=0; i < array_legal.length; i++) {
        extensions['eidas:RequestedAttributes'].push({
            'eidas:RequestedAttribute': requested_attributes.LegalPerson[array_legal[i]]
        })
    }

    for (var i=0; i < array_representative.length; i++) {
        extensions['eidas:RequestedAttributes'].push({
            'eidas:RequestedAttribute': requested_attributes.RepresentativeNaturalPerson[array_representative[i]]
        })
    }


    var xml = sp.create_authn_request_xml(idp, {
        extensions: extensions
    });

    process.stdout.write(xml);
};