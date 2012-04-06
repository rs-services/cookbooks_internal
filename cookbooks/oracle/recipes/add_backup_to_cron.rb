cron "rs_run_recipe --name oracle::backup_oracle_using_expdp" do
  command "rs_run_recipe --name oracle::backup_oracle_using_expdp"
  minute rand(60)
end
