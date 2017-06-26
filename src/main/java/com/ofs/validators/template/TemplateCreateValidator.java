package com.ofs.validators.template;

import com.ofs.model.Template;
import com.ofs.server.errors.BadRequestException;
import com.ofs.server.form.update.ChangeSet;
import com.ofs.server.model.OFSErrors;
import com.ofs.validations.TemplateCreateValidation;
import com.ofs.validators.Validator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class TemplateCreateValidator implements Validator<Template> {

    private final List<TemplateCreateValidation> VALIDATIONS = new ArrayList<>();

    @Autowired
    public TemplateCreateValidator(List<TemplateCreateValidation> validations) {
        validations.forEach(validation ->
                VALIDATIONS.add(validation)
        );
    }

    @Override
    public void validate(Template template, OFSErrors errors) throws Exception {
        for (TemplateCreateValidation validation : VALIDATIONS) {
            validation.validate(template, errors);
        }

        if(!errors.isEmpty()) {
            throw new BadRequestException(errors);
        }
    }

    @Override
    public void validate(ChangeSet changeSet, Template template, OFSErrors errors) throws Exception {
        for (TemplateCreateValidation validation : VALIDATIONS) {
            validation.validate(changeSet, template, errors);
        }

        if(!errors.isEmpty()) {
            throw new BadRequestException(errors);
        }
    }
}
