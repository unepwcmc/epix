module Cites::PermitLineItemMapping

  def id
    @body.at_xpath('urn1:ID').content
  end

  # Box 7

  def scientific_name
    @body.at_xpath('urn1:IncludedSupplyChainTradeLineItem/urn1:SpecifiedTradeProduct/urn1:ScientificName').content
  end

  # Box 8

  def common_name
    @body.at_xpath('urn1:IncludedSupplyChainTradeLineItem/urn1:SpecifiedTradeProduct/urn1:CommonName').content
  end

  # Box 9

  def term
    @body.at_xpath('urn1:IncludedSupplyChainTradeLineItem/urn1:SpecifiedTradeProduct/urn1:Description').content
  end

  def term_code
    @body.at_xpath('urn1:IncludedSupplyChainTradeLineItem/urn1:SpecifiedTradeProduct/urn1:TypeCode').content
  end

  def markings
    @body.at_xpath('urn1:PhysicalLogisticsShippingMarks/urn1:Marking').content
  end

  # Box 10

  def appendix
    @body.at_xpath('urn1:IncludedSupplyChainTradeLineItem/urn1:TypeCode').content
  end

  def source
    @body.at_xpath('urn1:IncludedSupplyChainTradeLineItem/urn1:TypeExtensionCode').content
  end

  # Box 11

  def quantity
    @body.at_xpath('urn1:TransportLogisticsPackage/urn1:ItemQuantity').content
  end

  def unit_code
    @body.at_xpath('urn1:TransportLogisticsPackage/urn1:ItemQuantity').attribute('unitCode')
  end

  # Box 11a

  def used_to_date_quantity
    applicable_cross_border_regulatory_procedure.at_xpath('urn1:UsedToDateQuotaQuantity').content
  end

  def used_to_date_unit_code
    applicable_cross_border_regulatory_procedure.at_xpath('urn1:UsedToDateQuotaQuantity').attribute('unitCode')
  end

  def annual_quota_quantity
    applicable_cross_border_regulatory_procedure.at_xpath('urn1:AnnualQuotaQuantity').content
  end

  def annual_quota_unit_code
    applicable_cross_border_regulatory_procedure.at_xpath('urn1:AnnualQuotaQuantity').attribute('unitCode')
  end

  # Box 12

  def origin_country
    @body.at_xpath('urn1:OriginTradeCountry/urn1:Name').content
  end

  def origin_permit_id
    origin_permit.at_xpath('urn1:ID').content
  end

  def origin_permit_date
    origin_permit.at_xpath('urn1:IssueDateTime').content
  end

  # Box 12a

  def export_country
    @body.at_xpath('urn1:ExportTradeCountry/urn1:Name').content
  end

  def export_permit_id
    export_permit.at_xpath('urn1:ID').content
  end

  def export_permit_date
    export_permit.at_xpath('urn1:IssueDateTime').content
  end

  # Box 12b

  def category_code
    applicable_cross_border_regulatory_procedure.at_xpath('urn1:CategoryCode').content
  end

  def acquisition_date_time
    applicable_cross_border_regulatory_procedure.at_xpath('urn1:AcquisitionDateTime').content
  end

  def operation_no
    previous_referenced_document = applicable_cross_border_regulatory_procedure.
      at_xpath('urn1:PreviousReferencedDocument')
    [
      previous_referenced_document.at_xpath('urn1:ID'),
      previous_referenced_document.at_xpath('urn1:Name')
    ].map(&:content).join(', ')
  end

  # Box 14

  def final_quantity
    @body.at_xpath('urn1:ExaminationTransportEvent/urn1:UnitQuantity').content
  end

  def final_unit_code
    @body.at_xpath('urn1:ExaminationTransportEvent/urn1:UnitQuantity').attribute('unitCode')
  end

  private

  def applicable_cross_border_regulatory_procedure
    @body.at_xpath('urn1:ApplicableCrossBorderRegulatoryProcedure')
  end

  def associated_referenced_documents
    @body.xpath('urn1:AssociatedReferencedDocument')
  end

  def origin_permit
    # TODO this is completely bonkers, basically trying to make it work with buggy data
    # TypeCode should be one of Export, Re-export, Import or Other
    associated_referenced_documents.select{|ard| ard.at_xpath('urn1:TypeCode').content == '861'}.first
  end

  def export_permit
    # TODO this is completely bonkers, basically trying to make it work with buggy data
    # TypeCode should be one of Export, Re-export, Import or Other
    associated_referenced_documents.select{|ard| ard.at_xpath('urn1:TypeCode').content == '811'}.first
  end

end
