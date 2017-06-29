package com.ofs.validations.template;

import com.ofs.model.Template;
import com.ofs.server.errors.UnauthorizedException;
import com.ofs.server.form.update.ChangeSet;
import com.ofs.server.model.OFSErrors;
import com.ofs.server.security.SecurityContext;
import com.ofs.server.security.Subject;

import com.ofs.validations.TemplateCompanyIdValidation;
import com.ofs.validations.TemplateGetValidation;
import org.springframework.stereotype.Component;

@Component
public class ValidateWarehouseRole implements TemplateGetValidation, TemplateCompanyIdValidation {

    @Override
    public void validate(Template template, OFSErrors errors) throws Exception {
        Subject subject = SecurityContext.getSubject();

        if(subject.getRole().equals("WAREHOUSE")) {
            throw new UnauthorizedException("OAuth", "OFSServer");
        }
    }

    @Override
    public void validate(ChangeSet changeSet, Template template, OFSErrors errors) throws Exception {
        validate(template, errors);
    }
}
