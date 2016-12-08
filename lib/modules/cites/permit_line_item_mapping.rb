module Cites::PermitLineItemMapping

  def id
    @body.at_xpath('ID').content
  end

  # Box 7

  def scientific_name
    @body.at_xpath('IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ScientificName').content
  end

  # Box 8

  def common_name
    @body.at_xpath('IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/CommonName').content
  end

  # Box 9

  def term
    @body.at_xpath('IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/Description').content
  end

  def term_code
    @body.at_xpath('IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/TypeCode').content
  end

  def markings
    @body.at_xpath('PhysicalLogisticsShippingMarks/Marking').try(:content)
  end

  # Box 10

  def appendix
    @body.at_xpath('IncludedSupplyChainTradeLineItem/TypeCode').content
  end

  def source
    @body.at_xpath('IncludedSupplyChainTradeLineItem/TypeExtensionCode').content
  end

  # Box 11

  def quantity
    @body.at_xpath('TransportLogisticsPackage/ItemQuantity').content
  end

  def unit_code
    @body.at_xpath('TransportLogisticsPackage/ItemQuantity').attribute('unitCode')
  end

  # Box 11a

  def used_to_date_quantity
    if applicable_cross_border_regulatory_procedure.present?
      applicable_cross_border_regulatory_procedure.at_xpath('UsedToDateQuotaQuantity').content
    end
  end

  def used_to_date_unit_code
    if applicable_cross_border_regulatory_procedure.present?
      applicable_cross_border_regulatory_procedure.at_xpath('UsedToDateQuotaQuantity').attribute('unitCode')
    end
  end

  def annual_quota_quantity
    if applicable_cross_border_regulatory_procedure.present?
      applicable_cross_border_regulatory_procedure.at_xpath('AnnualQuotaQuantity').content
    end
  end

  def annual_quota_unit_code
    if applicable_cross_border_regulatory_procedure.present?
      applicable_cross_border_regulatory_procedure.at_xpath('AnnualQuotaQuantity').attribute('unitCode')
    end
  end

  # Box 12

  def origin_country
    @body.at_xpath('OriginTradeCountry/Name').content
  end

  def origin_permit_id
    origin_permit.at_xpath('ID').content
  end

  def origin_permit_date
    origin_permit.at_xpath('IssueDateTime').content
  end

  # Box 12a

  def export_country
    @body.at_xpath('ExportTradeCountry/Name').content
  end

  def export_permit_id
    export_permit.at_xpath('ID').content
  end

  def export_permit_date
    export_permit.at_xpath('IssueDateTime').content
  end

  # Box 12b

  def category_code
    if applicable_cross_border_regulatory_procedure.present?
      applicable_cross_border_regulatory_procedure.at_xpath('CategoryCode').content
    end
  end

  def acquisition_date_time
    if applicable_cross_border_regulatory_procedure.present?
      applicable_cross_border_regulatory_procedure.at_xpath('AcquisitionDateTime').content
    end
  end

  def operation_no
    if applicable_cross_border_regulatory_procedure.present?
      previous_referenced_document = applicable_cross_border_regulatory_procedure.
        at_xpath('PreviousReferencedDocument')
      [
        previous_referenced_document.at_xpath('ID'),
        previous_referenced_document.at_xpath('Name')
      ].map(&:content).join(', ')
    end
  end

  # Box 14

  def final_quantity
    @body.at_xpath('ExaminationTransportEvent/UnitQuantity').try(:content)
  end

  def final_unit_code
    @body.at_xpath('ExaminationTransportEvent/UnitQuantity').try(:attribute, 'unitCode')
  end

  private

  def applicable_cross_border_regulatory_procedure
    @body.at_xpath('ApplicableCrossBorderRegulatoryProcedure')
  end

  def associated_referenced_documents
    @body.xpath('AssociatedReferencedDocument')
  end

  def origin_permit
    # TODO this is completely bonkers, basically trying to make it work with buggy data
    # TypeCode should be one of Export, Re-export, Import or Other
    associated_referenced_documents.select{|ard| ard.at_xpath('TypeCode').content == '861'}.first
  end

  def export_permit
    # TODO this is completely bonkers, basically trying to make it work with buggy data
    # TypeCode should be one of Export, Re-export, Import or Other
    associated_referenced_documents.select{|ard| ard.at_xpath('TypeCode').content == '811'}.first
  end

end
