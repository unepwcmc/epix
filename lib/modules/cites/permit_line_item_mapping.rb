module Cites::PermitLineItemMapping

  def id
    @body.at_xpath('ID').try(:content)
  end

  # Box 7

  def scientific_name
    @body.at_xpath('IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/ScientificName').try(:content)
  end

  # Box 8

  def common_name
    @body.at_xpath('IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/CommonName').try(:content)
  end

  # Box 9

  def term
    @body.at_xpath('IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/Description').try(:content)
  end

  def term_code
    @body.at_xpath('IncludedSupplyChainTradeLineItem/SpecifiedTradeProduct/TypeCode').try(:content)
  end

  def markings
    @body.at_xpath('PhysicalLogisticsShippingMarks/Marking').try(:content)
  end

  # Box 10

  def appendix
    @body.at_xpath('IncludedSupplyChainTradeLineItem/TypeCode').try(:content)
  end

  def source
    @body.at_xpath('IncludedSupplyChainTradeLineItem/TypeExtensionCode').try(:content)
  end

  # Box 11

  def quantity
    @body.at_xpath('TransportLogisticsPackage/ItemQuantity').try(:content)
  end

  def unit_code
    @body.at_xpath('TransportLogisticsPackage/ItemQuantity').attribute('unitCode')
  end

  # Box 11a

  def used_to_date_quantity
    if applicable_cross_border_regulatory_procedure.present?
      applicable_cross_border_regulatory_procedure.at_xpath('UsedToDateQuotaQuantity').try(:content)
    end
  end

  def used_to_date_unit_code
    if applicable_cross_border_regulatory_procedure.present?
      applicable_cross_border_regulatory_procedure.at_xpath('UsedToDateQuotaQuantity').try(:attribute, 'unitCode')
    end
  end

  def annual_quota_quantity
    if applicable_cross_border_regulatory_procedure.present?
      applicable_cross_border_regulatory_procedure.at_xpath('AnnualQuotaQuantity').try(:content)
    end
  end

  def annual_quota_unit_code
    if applicable_cross_border_regulatory_procedure.present?
      applicable_cross_border_regulatory_procedure.at_xpath('AnnualQuotaQuantity').try(:attribute, 'unitCode')
    end
  end

  # Box 12

  def origin_country
    @body.at_xpath('OriginTradeCountry/Name').try(:content)
  end

  def origin_permit_id
    origin_permit && origin_permit.at_xpath('ID').try(:content)
  end

  def origin_permit_date
    origin_permit && origin_permit.at_xpath('IssueDateTime').try(:content)
  end

  # Box 12a

  def export_country
    @body.at_xpath('ExportTradeCountry/Name').try(:content)
  end

  def export_permit_id
    export_permit && export_permit.at_xpath('ID').try(:content)
  end

  def export_permit_date
    export_permit && export_permit.at_xpath('IssueDateTime').try(:content)
  end

  # Box 12b

  def category_code
    if applicable_cross_border_regulatory_procedure.present?
      applicable_cross_border_regulatory_procedure.at_xpath('CategoryCode').try(:content)
    end
  end

  def acquisition_date_time
    if applicable_cross_border_regulatory_procedure.present?
      applicable_cross_border_regulatory_procedure.at_xpath('AcquisitionDateTime').try(:content)
    end
  end

  def operation_no
    if applicable_cross_border_regulatory_procedure.present?
      previous_referenced_document = applicable_cross_border_regulatory_procedure.
        at_xpath('PreviousReferencedDocument')
      if previous_referenced_document
        [
          previous_referenced_document.at_xpath('ID'),
          previous_referenced_document.at_xpath('Name')
        ].map(&:content).join(', ')
      end
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
    associated_referenced_documents.select{|ard| ard.at_xpath('TypeCode').try(:content) == '861'}.first
  end

  def export_permit
    # TODO this is completely bonkers, basically trying to make it work with buggy data
    # TypeCode should be one of Export, Re-export, Import or Other
    associated_referenced_documents.select{|ard| ard.at_xpath('TypeCode').try(:content) == '811'}.first
  end

end
