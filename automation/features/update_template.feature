@service
Feature: Template is update when template endpoint is called

  Scenario: A request to update a template is received by a SYSTEM_ADMIN
    Given A SYSTEM_ADMIN user exists and template exists for a company
    When A request to update a template is received
    Then the response should have a status of 204
    And I should see the template was updated

  Scenario: A request to update a template is received by a ADMIN
    Given A ADMIN user exists and template exists for a company
    When A request to update a template is received
    Then the response should have a status of 204
    And I should see the template was updated

  Scenario: A request to update a template is received by a ACCOUNT_MANAGER
    Given A ACCOUNT_MANAGER user exists and template exists for a company
    When A request to update a template is received
    Then the response should have a status of 204
    And I should see the template was updated

  Scenario: A request to update a template is received by a WAREHOUSE
    Given A WAREHOUSE user exists and template exists for a company
    When A request to update a template is received
    Then the response should have a status of 400

  Scenario: A request to update a template is received by a CUSTOMER
    Given A CUSTOMER user exists and template exists for a company
    When A request to update a template is received
    Then the response should have a status of 400

  Scenario: A request to update a template that does not exists is received by a ADMIN
    Given A ADMIN user exists and template does not exists
    When A request to update a template that does not exists is received
    Then the response should have a status of 404

  Scenario: A request to update a templates name is received by a ADMIN
    Given A ADMIN user exists and template exists for a company
    When A request to update a template name is received
    Then the response should have a status of 204
    And I should see the template name was updated

  Scenario: A request to update a templates props is received by a ADMIN
    Given A ADMIN user exists and template exists for a company
    When A request to update a template props is received
    Then the response should have a status of 204
    And I should see the template props were updated

  Scenario: A request to get templates by company id is received by a ADMIN
    Given User authenticate service returns an exception
    When A request to update a template is received
    Then the response should have a status of 403

  Scenario: A request to get templates by company id is received by a ADMIN
    Given A ADMIN user does not exists for a company
    When A request to update a template is received
    Then the response should have a status of 403

  Scenario: A request to update a template id is received by a ADMIN
    Given A ADMIN user exists and template exists for a company
    When A request to update a template id is received
    Then the response should have a status of 400
    And I should see an error message with id not allowed

  Scenario: A request to update a template href is received by a ADMIN
    Given A ADMIN user exists and template exists for a company
    When A request to update a template href is received
    Then the response should have a status of 400
    And I should see an error message with href not allowed

  Scenario: A request to update a template createdOn is received by a ADMIN
    Given A ADMIN user exists and template exists for a company
    When A request to update a template createdOn is received
    Then the response should have a status of 400
    And I should see an error message with createdOn not allowed

  Scenario: A request to update a template companyId is received by a ADMIN
    Given A ADMIN user exists and template exists for a company
    When A request to update a template companyId is received
    Then the response should have a status of 400
    And I should see an error message with companyId not allowed

  Scenario: A request to update a template with duplicate props
    Given A ADMIN user exists and template exists for a company
    When A request to update a template with duplicate props
    Then the response should have a status of 400
    And I should see an error message indicating duplicate props

  Scenario: A request to update a template with new props required field and default value is missing
    Given A ADMIN user exists and template exists for a company
    When A request is made to update a template props with new required field and defaultValue is missing
    Then the response should have a status of 400
    And I should see an error message indicating default value missing

  Scenario: A request to update a template with new props with no required fields and default value is missing
    Given A ADMIN user exists and template exists for a company
    When A request is made to update a template props with no required field and defaultValue is missing
    Then the response should have a status of 204
    And I should see the template was updated

  Scenario: A request to update a template with invalid defaultValue type
    Given A ADMIN user exists and template exists for a company
    When A request is made to update a template props with invalid NUMBER defaultValue
    Then the response should have a status of 400
    And I should see an error message indicating invalid prop value

  Scenario: A request to update a template with invalid defaultValue type
    Given A ADMIN user exists and template exists for a company
    When A request is made to update a template props with invalid BOOLEAN defaultValue
    Then the response should have a status of 400

  Scenario: A request to update a template with valid defaultValue type
    Given A ADMIN user exists and template exists for a company
    When A request is made to update a template props with valid defaultValue type
    Then the response should have a status of 204
    And I should see the template was updated

  Scenario: A request to update a template with no new props
    Given A ADMIN user exists and template exists for a company
    When A request is made to update a template with no new props
    Then the response should have a status of 204
    And I should see the template was updated

  Scenario: A request to update a template with new props should update inventory props that use template
    Given A ADMIN user exists and inventory item exists for a company
    When A request is made to update a templates props
    Then the response should have a status of 204
    And I should see inventory for that template was updated with new props

  Scenario: A request to update a template with new props when inventory does not exists for that company
    Given A ADMIN user exists and template exists for a company
    When A request is made to update a template props
    Then the response should have a status of 204
    And I should see the template was updated

  Scenario: A request to update a template with new props when no inventory uses template
    Given A company exists with an ADMIN user, template, and inventory not for that template
    When A request is made to update a templates props
    Then the response should have a status of 204
    And I should see inventory for that template was not updated with new props
