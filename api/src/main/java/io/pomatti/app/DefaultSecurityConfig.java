package io.pomatti.app;

import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationEventPublisher;
import org.springframework.security.authentication.DefaultAuthenticationEventPublisher;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;

@EnableWebSecurity
@Configuration
public class DefaultSecurityConfig {

  @Bean
  @ConditionalOnMissingBean(UserDetailsService.class)
  public InMemoryUserDetailsManager inMemoryUserDetailsManager() {
    InMemoryUserDetailsManager manager = new InMemoryUserDetailsManager();
    String generatedPassword = "{noop}p4ssw0rd";
    UserDetails client = User.withUsername("client")
        .password(generatedPassword)
        .roles("USER")
        .build();

    UserDetails lambda = User.withUsername("lambda")
        .password(generatedPassword)
        .roles("USER")
        .build();

    manager.createUser(client);
    manager.createUser(lambda);

    return manager;
  }

  @Bean
  @ConditionalOnMissingBean(AuthenticationEventPublisher.class)
  public DefaultAuthenticationEventPublisher defaultAuthenticationEventPublisher(ApplicationEventPublisher delegate) {
    return new DefaultAuthenticationEventPublisher(delegate);
  }
}
