package com.ofs.validations.template;

import com.ofs.model.Template;
import com.ofs.server.form.update.ChangeSet;
import com.ofs.server.model.OFSErrors;
import com.ofs.validations.TemplateCreateValidation;
import com.ofs.validations.TemplateUpdateValidation;
import com.ofs.validations.props.ValidateDuplicateProps;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class ValidateTemplateDuplicateProps implements TemplateCreateValidation, TemplateUpdateValidation {

    @Autowired
    ValidateDuplicateProps validateDuplicateProps;

    @Override
    public void validate(Template template, OFSErrors errors) throws Exception {
        validateDuplicateProps.validate(template.getProps(), errors);
    }

    @Override
    public void validate(ChangeSet changeSet, Template template, OFSErrors errors) throws Exception {
        validate(template, errors);
    }
}
