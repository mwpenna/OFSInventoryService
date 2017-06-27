package com.ofs.controller;

import com.ofs.model.Template;
import com.ofs.repository.TemplateRepository;
import com.ofs.server.OFSController;
import com.ofs.server.OFSServerId;
import com.ofs.server.form.OFSServerForm;
import com.ofs.server.form.ValidationSchema;
import com.ofs.server.model.OFSErrors;
import com.ofs.server.security.Authenticate;
import com.ofs.server.security.SecurityContext;
import com.ofs.server.security.Subject;
import com.ofs.utils.StringUtils;
import com.ofs.validators.template.TemplateCreateValidator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.net.URI;

@OFSController
@RequestMapping(value="/inventory/template", produces = MediaType.APPLICATION_JSON_VALUE)
public class TemplateController {

    @Autowired
    private TemplateRepository templateRepository;

    @Autowired
    private  TemplateCreateValidator templateCreateValidator;

    @PostMapping(consumes = MediaType.APPLICATION_JSON_VALUE)
    @ValidationSchema(value = "/template-create.json")
    @Authenticate
    @CrossOrigin(origins = "*")
    public ResponseEntity create(@OFSServerId URI id, OFSServerForm<Template> form) throws Exception{
        Template template = form.create(id);
        defaultValues(template);

        OFSErrors errors = new OFSErrors();
        templateCreateValidator.validate(template, errors);

        templateRepository.addTemplate(template);
        return ResponseEntity.created(id).build();
    }

    private void defaultValues(Template template) {
        Subject subject = SecurityContext.getSubject();

        if(!subject.getRole().equalsIgnoreCase("SYSTEM_ADMIN") || template.getCompanyId()==null) {
            template.setCompanyId(StringUtils.getIdFromURI(subject.getCompanyHref()));
        }
    }
}
