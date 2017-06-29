package com.ofs.validations.template;

import com.ofs.model.Template;
import com.ofs.server.errors.UnauthorizedException;
import com.ofs.server.form.update.ChangeSet;
import com.ofs.server.model.OFSErrors;
import com.ofs.server.security.SecurityContext;
import com.ofs.server.security.Subject;
import com.ofs.utils.StringUtils;

import com.ofs.validations.TemplateGetValidation;
import org.springframework.stereotype.Component;

@Component
public class ValidateAccountManagerRole implements TemplateGetValidation {
    @Override
    public void validate(Template template, OFSErrors errors) throws Exception {
        Subject subject = SecurityContext.getSubject();

        if(subject.getRole().equals("ACCOUNT_MANAGER")) {
            if(!StringUtils.getIdFromURI(subject.getCompanyHref()).equals(template.getCompanyId())) {
                throw new UnauthorizedException("OAuth", "OFSServer");
            }
        }
    }

    @Override
    public void validate(ChangeSet changeSet, Template template, OFSErrors errors) throws Exception {
        validate(template, errors);
    }
}
