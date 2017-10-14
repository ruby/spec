module SetSpecs
  class ByIdentityKey
    def hash
      fail("#hash should not be called on compare_by_identity Set")
    end
  end
end
