package com.ofs.validators.template;

import com.ofs.server.errors.BadRequestException;
import com.ofs.server.form.update.ChangeSet;
import com.ofs.server.model.OFSErrors;
import com.ofs.validations.TemplateDeleteValidation;
import com.ofs.validators.Validator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class TemplateDeleteValidator implements Validator<String> {

    private final List<TemplateDeleteValidation> VALIDATIONS = new ArrayList<>();

    @Autowired
    public TemplateDeleteValidator(List<TemplateDeleteValidation> validations) {
        validations.forEach(validation ->
                VALIDATIONS.add(validation)
        );
    }

    @Override
    public void validate(String id, OFSErrors errors) throws Exception {
        for (TemplateDeleteValidation validation : VALIDATIONS) {
            validation.validate(id, errors);
        }

        if(!errors.isEmpty()) {
            throw new BadRequestException(errors);
        }
    }

    @Override
    public void validate(ChangeSet changeSet, String id, OFSErrors errors) throws Exception {
        for (TemplateDeleteValidation validation : VALIDATIONS) {
            validation.validate(changeSet, id, errors);
        }

        if(!errors.isEmpty()) {
            throw new BadRequestException(errors);
        }
    }
}
