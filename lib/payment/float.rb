module Payment::Float
  def ~@
    Payment::Money.new self
  end
  
  def =~ other
    return super unless other.class == Float
    self - other < Payment::EPSILON
  end
end
