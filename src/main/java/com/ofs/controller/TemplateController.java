package com.ofs.controller;

import com.ofs.model.Template;
import com.ofs.server.OFSController;
import com.ofs.server.OFSServerId;
import com.ofs.server.form.OFSServerForm;
import com.ofs.server.form.ValidationSchema;
import com.ofs.server.security.Authenticate;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.net.URI;

@OFSController
@RequestMapping(value="/inventory/template", produces = MediaType.APPLICATION_JSON_VALUE)
public class TemplateController {

    @PostMapping(consumes = MediaType.APPLICATION_JSON_VALUE)
    @ValidationSchema(value = "/template-create.json")
    @Authenticate
    @CrossOrigin(origins = "*")
    public ResponseEntity create(@OFSServerId URI id, OFSServerForm<Template> form) throws Exception{
        form.create(id);
        return ResponseEntity.created(id).build();
    }
}
