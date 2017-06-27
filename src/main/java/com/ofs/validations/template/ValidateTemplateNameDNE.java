package com.ofs.validations.template;

import com.ofs.model.Template;
import com.ofs.repository.TemplateRepository;
import com.ofs.server.form.update.ChangeSet;
import com.ofs.server.model.OFSErrors;
import com.ofs.validations.TemplateCreateValidation;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Optional;

public class ValidateTemplateNameDNE implements TemplateCreateValidation {

    @Autowired
    private TemplateRepository templateRepository;

    @Override
    public void validate(Template template, OFSErrors errors) throws Exception {
        Optional optionalTemplate = templateRepository.getTemplateByName(template.getName(), template.getCompanyHref().toString());

        if(optionalTemplate.isPresent()) {
            errors.rejectValue("template.name.exists", "template.name", "Invalid template name. Template already exists.");
        }
    }

    @Override
    public void validate(ChangeSet changeSet, Template template, OFSErrors errors) throws Exception {
        validate(template, errors);
    }
}
