package com.ofs.controller;

import com.ofs.model.Template;
import com.ofs.repository.TemplateRepository;
import com.ofs.server.OFSController;
import com.ofs.server.OFSServerId;
import com.ofs.server.errors.NotFoundException;
import com.ofs.server.form.OFSServerForm;
import com.ofs.server.form.ValidationSchema;
import com.ofs.server.model.OFSErrors;
import com.ofs.server.security.Authenticate;
import com.ofs.server.security.SecurityContext;
import com.ofs.server.security.Subject;
import com.ofs.utils.StringUtils;
import com.ofs.validators.template.TemplateCompanyIdValidator;
import com.ofs.validators.template.TemplateCreateValidator;
import com.ofs.validators.template.TemplateDeleteValidator;
import com.ofs.validators.template.TemplateGetValidator;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.net.URI;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@OFSController
@RequestMapping(value="/inventory/template", produces = MediaType.APPLICATION_JSON_VALUE)
@Slf4j
public class TemplateController {

    @Autowired
    private TemplateRepository templateRepository;

    @Autowired
    private  TemplateCreateValidator templateCreateValidator;

    @Autowired
    private TemplateGetValidator templateGetValidator;

    @Autowired
    private TemplateCompanyIdValidator templateCompanyIdValidator;

    @Autowired
    private TemplateDeleteValidator templateDeleteValidator;

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

    @GetMapping(value = "/id/{id}")
    @Authenticate
    @CrossOrigin(origins = "*")
    public Template getById(@PathVariable("id") String id) throws Exception {
        log.info("Retreiving template with id: {}", id);
        Optional<Template> templateOptional = templateRepository.getTemplateById(id);

        if(templateOptional.isPresent()) {
            Template template = templateOptional.get();
            OFSErrors ofsErrors = new OFSErrors();
            templateGetValidator.validate(template, ofsErrors);

            return template;
        }
        else {
            log.warn("Template with id: {} not found", id);
            throw new NotFoundException();
        }

    }

    @ResponseBody
    @GetMapping(value = "/company/id/{id}")
    @Authenticate
    @CrossOrigin(origins = "*")
    public List<Template> getByCompanyId(@PathVariable("id") String companyId) throws Exception {
        log.info("Retreiving templates with companyId: {}", companyId);
        Optional<List<Template>> templateListOptional = templateRepository.getTemplateByCompanyId(companyId);

        OFSErrors ofsErrors = new OFSErrors();
        templateCompanyIdValidator.validate(null, ofsErrors);

        if(templateListOptional.isPresent()) {
            return templateListOptional.get();
        }
        else {
            return new ArrayList<>();
        }
    }

    @DeleteMapping(value = "/id/{id}")
    @Authenticate
    @CrossOrigin(origins = "*")
    public ResponseEntity deleteTemplateById(@PathVariable("id") String templateId) throws Exception {
        log.info("Deleting template with id: {}", templateId);

        OFSErrors ofsErrors = new OFSErrors();
        templateDeleteValidator.validate(templateId, ofsErrors);

        templateRepository.deleteTemplateById(templateId);
        return ResponseEntity.noContent().build();
    }

    private void defaultValues(Template template) {
        Subject subject = SecurityContext.getSubject();

        if(!subject.getRole().equalsIgnoreCase("SYSTEM_ADMIN") || template.getCompanyId()==null) {
            template.setCompanyId(StringUtils.getIdFromURI(subject.getCompanyHref()));
        }
    }
}
