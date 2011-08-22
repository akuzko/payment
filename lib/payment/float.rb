module Payment::Float
  def ~@
    Money.new self
  end
  
  def =~ other
    return super unless other.class == Float
    self - other < Payment::Precision
  end
end
