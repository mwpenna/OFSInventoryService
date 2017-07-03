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
